# 2.0.0

This a fork of https://github.com/careapp-group/zxcvbn-dart, which updates the implementation to bring it up-to-date with the latest Dart version, while also including various improvements in terms of null-safety and changes brought by the modern rewrite of the algorithm (https://github.com/zxcvbn-ts/zxcvbn).

- Improved null-safety
    - Removed excessive usage of "!"
- Updated the L33t table with more substitutions
- Improved type safety (replaced usages of "dynamic")
- Added Levenshtein distance matching (from zxcvbn-ts)
    - Detects passwords that are typos of common dictionary words
    - Configurable via `USE_LEVENSHTEIN_DISTANCE` and `LEVENSHTEIN_THRESHOLD` settings
    - Only applies to full passwords to minimize performance impact
    - Automatically adjusts threshold for short passwords
- Include fixes from 3 pull requests to the original repository. ([b235200](https://github.com/careapp-group/zxcvbn-dart/pull/11/commits/b2352005b9ec356f860453044173fd4cd3b2600b), [079d182](https://github.com/careapp-group/zxcvbn-dart/pull/12/commits/079d18290d5afdea498be55d67a43a40a5c3c6fb), [e4f82fa](https://github.com/careapp-group/zxcvbn-dart/pull/13/commits/e4f82fa7f987319b7a13728657a195b9e0895b99))

# 1.0.0

Null Safety! Thanks to @lmordell and @hpoul for their contributions.

# 0.0.1

Initial version.

- Port of Coffee Script to Dart.
- Port all tests.
- Verify behaviour
