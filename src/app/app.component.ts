import {AfterViewInit, Component} from '@angular/core';
import {environment} from "../environments/environment";
// @ts-ignore
import * as config from "./config.json";

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements AfterViewInit {
  title = 'test-app';
  public environmentNew: any = {MESSAGE: 'init', POD_NAME: 'init'};

  ngAfterViewInit(): void {
    this.environmentNew = environment;
    console.log("environment", environment);
    console.log("config", config);
  }

}
