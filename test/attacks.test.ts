import { loadFixture } from '@nomicfoundation/hardhat-network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';

// eslint-disable-next-line camelcase
import { Attacker__factory, ERC20Token__factory } from '../typechain-types';

describe('Attacks tests', function () {
  async function deployment() {
    const signer = await ethers.provider.getSigner(0);
    const signer1 = await ethers.provider.getSigner(1);
    const token = await new ERC20Token__factory(signer);
    const Token = await token.deploy('TestERC20');
    const attacker = await new Attacker__factory(signer1);
    const Attacker = await attacker.deploy(Token.address, signer.getAddress());

    return { signer, signer1, Token, Attacker };
  }
  describe('Reentrancy attacks', async function () {
    it('Reentrancy attack', async function () {
      const { Token, Attacker } = await loadFixture(deployment);
      await Token.deposit({ value: ethers.utils.parseEther('100') });
      const ethersToWei = await ethers.utils.parseUnits('-100', 'ether');
      await expect(
        Attacker.attack({ value: ethers.utils.parseEther('10') }),
      ).to.changeEtherBalance(Token, ethersToWei);
    });
  });
});
