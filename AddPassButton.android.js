/**
 * @flow
 */
'use strict'

import * as React from 'react'
import { View, ViewPropTypes } from 'react-native'
import PropTypes from 'prop-types'

export class AddPassButton extends React.Component<*> {
  static propTypes = {
    ...(ViewPropTypes || View.propTypes),
    addPassButtonStyle: PropTypes.number,
    onPress: PropTypes.func,
  }

  componentDidMount(): void {
  }

  render(): React.Node {
    return null
  }
}
