/* eslint-disable @typescript-eslint/naming-convention */
import { registerPlugin } from '@capacitor/core';

export interface NthPhotoPlugin {
  getNthPhoto(options: { photoAt: string }): Promise<{ image: string }>;
}

const NthPhoto = registerPlugin<NthPhotoPlugin>('NthPhotoPlugin');

export default NthPhoto;
