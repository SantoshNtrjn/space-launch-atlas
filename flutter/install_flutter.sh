#!/bin/bash
# Install Flutter SDK
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PWD/flutter/bin:$PATH"
flutter doctor