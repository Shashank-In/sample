module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testRunner: 'jest-circus/runner',
  testPathIgnorePatterns: ['/node_modules/', 'dist/'],
}
