# react-native-passkit-wallet
React Native module to handle PassKit pass.

## Installation

### 1. Install library from `npm`

```shell
npm install --save react-native-passkit-wallet
```

### 2. Link native code

You can link native code in the way you prefer:

#### CocoaPods

Add line to your project target section in your Podfile:

```diff
target 'YourProjectTarget' do

+   pod 'react-native-passkit-wallet', path: '../node_modules/react-native-passkit-wallet'

end
```

If you received error `jest-haste-map: Haste module naming collision: Duplicate module name: react-native`, add lines below to your Podfile and reinstall pods.

```diff
target 'YourProjectTarget' do

+   rn_path = '../node_modules/react-native'
+   pod 'yoga', path: "#{rn_path}/ReactCommon/yoga/yoga.podspec"
+   pod 'React', path: rn_path

  pod 'react-native-passkit-wallet', path: '../node_modules/react-native-passkit-wallet'

end

+ post_install do |installer|
+   installer.pods_project.targets.each do |target|
+     if target.name == "React"
+       target.remove_from_project
+     end
+   end
+ end
```

#### react-native link

Run command below:

```shell
react-native link react-native-passkit-wallet
```

### 3. Android configuration

1.  Add following lines to AndroidManifest.xml

    ```diff
    <manifest
      ...
    + xmlns:tools="http://schemas.android.com/tools"
    >
      <application ...>
        ...
    +   <provider
    +     android:name="androidx.core.content.FileProvider"
    +     android:authorities="com.yourcompany.fileprovider"
    +     android:grantUriPermissions="true"
    +     android:exported="false"
    +     tools:replace="android:authorities">
    +     <meta-data
    +       android:name="android.support.FILE_PROVIDER_PATHS"
    +       android:resource="@xml/passkit_file_paths"
    +       tools:replace="android:resource" />
    +   </provider>
      </application>
    </manifest>
    ```

1.  Create passkit_file_paths.xml

    Create `passkit_file_paths.xml` file in your project's `android/app/src/main/res/xml` directory.
    pkpass file will be created in your app's cache directory.

    ```xml
    <paths xmlns:android="http://schemas.android.com/apk/res/android">
        <cache-path name="passkit" path="/"/>
    </paths>
    ```

## Usage

```jsx
import PassKit, { AddPassButton } from 'react-native-passkit-wallet'
```

### Check whether the device supports adding passes

```jsx
PassKit.canAddPasses()
  .then((result) => {
    console.log(result)
  })
```

For Android, `true` will be returned if apps that can open pkpass files are installed.

### Prompt the user to add the pass to the pass library

```jsx
PassKit.addPass(base64EncodedPass)
```

For Android, file provider has to be specified for the second argument.
And a dialogue box will appear to choose an app to open the pass.

```jsx
PassKit.addPass(base64EncodedPass, 'com.yourcompany.fileprovider')
```

### Check whether the user’s pass library contains the specified pass (iOS only)

```jsx
PassKit.containsPass(base64EncodedPass)
```

### Display a button that enables users to add passes to Wallet (iOS only)

```jsx
class App extends Component<{}> {
  render() {
    return (
      <AddPassButton
        style={styles.addPassButton}
        addPassButtonStyle={PassKit.AddPassButtonStyle.black}
        onPress={() => { console.log('onPress') }}
      />
    )
  }
}
```

### Handle events (iOS only)

```jsx
class App extends Component<{}> {
  // To keep the context of 'this'
  onAddPassesViewControllerDidFinish = this.onAddPassesViewControllerDidFinish.bind(this)

  componentDidMount() {
    // Add event listener
    PassKit.addEventListener('addPassesViewControllerDidFinish', this.onAddPassesViewControllerDidFinish)
  }

  componentWillUnmount() {
    // Remove event listener
    PassKit.removeEventListener('addPassesViewControllerDidFinish', this.onAddPassesViewControllerDidFinish)
  }

  onAddPassesViewControllerDidFinish() {
    // Add-passes view controller has been dismissed
    console.log('onAddPassesViewControllerDidFinish')
  }
}
```

### Constants (iOS only)

- *PassKit.AddPassButtonStyle* - The appearance of the add-pass button
    - *black* - A black button with white lettering
    - *blackOutline* - A black button with a light outline
- *PassKit.AddPassButtonWidth* - Default add-pass button width
- *PassKit.AddPassButtonHeight* - Default add-pass button height
