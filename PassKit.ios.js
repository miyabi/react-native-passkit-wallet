/**
 * @flow
 */
/* global module */
'use strict'

import { NativeModules, NativeEventEmitter } from 'react-native'
import type EmitterSubscription from 'EmitterSubscription'

const nativeModule = NativeModules.RNPassKit
const nativeEventEmitter = new NativeEventEmitter(nativeModule)

const PassKit = {
  ...nativeModule,

  addEventListener: (
    eventType: string,
    listener: Function,
    context: ?Object,
  ): ?EmitterSubscription => (
    nativeEventEmitter.addListener(eventType, listener, context)
  ),

  removeEventListener: (eventType: string, listener: Function): void => {
    nativeEventEmitter.removeListener(eventType, listener)
  },
}

module.exports = { PassKit }
