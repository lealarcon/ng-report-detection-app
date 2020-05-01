
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { map } from 'rxjs/operators';




@Injectable({
  providedIn: 'root'
})
export class HttpService {

  public urlHttp: string = 'https://api.wiridlab.site/api';
  private TOKEN = 'iJQG4Ltd6Y5fvlnpQJH-FrbqGo7mOp3R'
  constructor(
    private http: HttpClient
  ) {


    console.log('url:', this.urlHttp);

  }

  getHeader(): HttpHeaders {
    let headers = new HttpHeaders({
      'Content-Type': 'application/json',
      "Accept": "application/json",
      'X-Auth-Token': this.TOKEN,
    });
    return headers;
  }

  httpGet(url: string): any {
    return this.http.get(this.urlHttp + url, { headers: this.getHeader() });
  }

  httpPost(url: string, data: any): any {
    return this.http.post(this.urlHttp + url, data, { headers: this.getHeader() });
  }

}
