import express = require('express');
import { Request, Response } from 'express';
import * as _ from 'lodash';
import moment = require('moment');
import notifier from 'node-notifier';
import { inspect } from 'util';

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

interface IAlert {
  status: string;
  labels: {
    alertname: string;
    hostname: string;
    monitor: string;
    severity: string;
  };
  annotations: { summary: string };
  startsAt: string;
  endsAt: string;
  generatorURL: string;
}

interface IAlertNotification {
  receiver: string;
  status: string;
  alerts: IAlert[];
  groupLabels: { alertname: string };
  commonLabels: {
    alertname: string;
    hostname?: string;
    monitor: string;
    severity: string;
  };
  commonAnnotations: { summary: string };
  externalURL: string;
  version: string;
  groupKey: string;
}

const isAlert = (alert: any): alert is IAlertNotification => {
  return !!alert.receiver && !!alert.status;
};

app.post('/', (req: Request, res: Response) => {
  if (isAlert(req.body)) {
    const sumStatus = (keyword: string, alertData: IAlert): any[] =>
      isAlert(alertData) ? alertData.alerts.map(a => a[keyword]) : [];
    const statusStr = (keyword: string, alertData: IAlert) =>
      sumStatus(keyword, alertData).join(' ');
    const [hostnames, status] = ['hostname', 'status'].map(s =>
      statusStr(s, req.body)
    );

    notifier.notify({
      title:
        `${req.body.commonLabels.severity}: ${status} (${req.body.alerts.length}) ` +
        `"${req.body.commonLabels.alertname}" ${hostnames}`,
      message: inspect(req.body.alerts, false, 4)
    });
    console.log(moment().format(), inspect(req.body, false, 4));
    res.send('');
  } else {
    res.send("data doesn't have the right format");
  }
});

app.get('/', (req, res) => {
  res.send('GET requests are not supported, use POST instead');
});

app.listen(9099, () =>
  console.log(`Alertmanager webhook receiver listening on port 9099`)
);
