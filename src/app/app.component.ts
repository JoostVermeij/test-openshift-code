import {AfterViewInit, Component} from '@angular/core';
import {Env} from './env';
import {environment} from "../environments/environment";
import {process} from 'angular-server-side-configuration/process';
import {HttpClient} from "@angular/common/http";
import {map} from 'rxjs';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements AfterViewInit {
  title = 'test-app';
  public environmentNew: any = {MESSAGE: 'init', POD_NAME: 'init'};

  constructor(public http: HttpClient) {
  }

  ngAfterViewInit(): void {
    this.environmentNew = environment;
    console.log("env", process, process.env);
    console.log("environment", environment, environment.MESSAGE, environment.POD_NAME)

    this.http.get('assets/json/runtime.json')
      .pipe(map(result =>
        {
           console.log(result);
        }
      )).subscribe();
  }

}
