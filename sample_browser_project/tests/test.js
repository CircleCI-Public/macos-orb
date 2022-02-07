const { Builder, By, Key, until } = require('selenium-webdriver');
const { assert, expect } = require('chai');

describe('CircleCI Tests', function() {
    const driver = new Builder().forBrowser("safari").build();

    describe('Load macOS Orb Dev Hub Page', async function() {
        it('Should load macOS Orb Dev Hub Page', async function() {
            await driver.get('https://circleci.com/developer/orbs/orb/circleci/macos');
        });
    });

    after(function() {
        driver.quit();
    });
});