import { CommonModule } from '@angular/common';
import { ChangeDetectionStrategy, Component, NgModule } from '@angular/core';
import { DomSanitizer } from '@angular/platform-browser';
import { RouterModule } from '@angular/router';
import { IonicModule } from '@ionic/angular';
import NthPhoto from '../shared/plugins/nth-photo-plugin';

@Component({
  selector: 'app-home',
  template: `
    <ion-header>
      <ion-toolbar>
        <ion-title> Get Nth Photo </ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content>
      <ion-button (click)="getPhoto()">Get photo</ion-button>
      <img [src]="domSanitizer.bypassSecurityTrustUrl(lastPhoto)" />
    </ion-content>
  `,
})
export class HomePage {
  lastPhoto = 'http://placehold.it/500x500';

  constructor(public domSanitizer: DomSanitizer) {}

  async getPhoto() {
    const result = await NthPhoto.getNthPhoto({ photoAt: '5' });
    console.log(result);
    this.lastPhoto = 'data:image/png;base64, ' + result.image;
  }
}

@NgModule({
  declarations: [HomePage],
  imports: [
    IonicModule,
    CommonModule,
    RouterModule.forChild([
      {
        path: '',
        component: HomePage,
      },
    ]),
  ],
})
export class HomePageModule {}
