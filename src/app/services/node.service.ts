import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';


// Services
import { HttpService } from './http.service';



@Injectable({
  providedIn: 'root'
})
export class NodeService {

  constructor(
    private _httpService: HttpService,
    private _router: Router,
  ) { }


  // Funciones Propias
  getDataByNodeId(nodeId, filter?: string): Observable<any[]> {
    let url: string = `/devices/${nodeId}`;
    if (filter)
      url = `/devices/${nodeId}?filter=${filter}`;
    return this._httpService.httpGet(url);
  }

// Funciones Propias
  getAllNodes( filter?: string): Observable<any[]> {
    let url: string = `/MyNodes`;
    if (filter)
      url = `/MyNodes?filter=${filter}`;
    return this._httpService.httpGet(url);
  }


  



}
