import * as React from 'react';
import { EmitterSubscription, ViewProperties } from 'react-native';

declare class PassKit {
  static canAddPasses(): Promise<boolean>;
  static addPass(base64Encoded: string, fileProvider?: string): Promise<void>;
  static presentAddPassesViewController(base64Encoded: string): Promise<void>;
  static addEventListener(
    eventType: string,
    listener: Function,
    context?: Object,
  ): EmitterSubscription;
  static removeEventListener(eventType: string, listener: Function): void;
}

interface AddPassButtonProps extends ViewProperties {
  addPassButtonStyle: number;
  onPress: Function;
}

export declare class AddPassButton extends React.Component<
  AddPassButtonProps
> {}

export default PassKit;
