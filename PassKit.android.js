/**
 * @flow
 */
/* global module */
'use strict'

import type EmitterSubscription from 'EmitterSubscription'

export default {
  canAddPasses: (): Promise<boolean> => (
    Promise.resolve(false)
  ),

  presentAddPassesViewController: (base64Encoded: string): Promise<void> => (
    Promise.resolve()
  ),

  addEventListener: (
    eventType: string,
    listener: Function,
    context: ?Object,
  ): ?EmitterSubscription => (
    null
  ),

  removeEventListener: (eventType: string, listener: Function): void => {},
}
