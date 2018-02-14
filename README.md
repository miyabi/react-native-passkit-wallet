# react-native-passkit-wallet
React Native module to handle PassKit.

## Usage
```jsx
import { PassKit, AddPassButton } from 'react-native-passkit-wallet'
```

### Check whether the device supports adding passes
```jsx
PassKit.canAddPasses()
  .then((result) => {
    console.log(result)
  })
```

### Display a button that enables users to add passes to Wallet
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

### Show a pass and prompt the user to add that pass to the pass library
```jsx
PassKit.presentAddPassesViewController(base64EncodedPass)
```

### Handle events
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

### Constants
- *PassKit.AddPassButtonStyle* - The appearance of the add-pass button
  - *black* - A black button with white lettering
  - *blackOutline* - A black button with a light outline
- *PassKit.AddPassButtonWidth* - Default add-pass button width
- *PassKit.AddPassButtonHeight* - Default add-pass button height
