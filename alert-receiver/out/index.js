"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express = require("express");
const moment = require("moment");
const node_notifier_1 = __importDefault(require("node-notifier"));
const util_1 = require("util");
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const isAlert = (alert) => {
    return !!alert.receiver && !!alert.status;
};
app.post('/', (req, res) => {
    if (isAlert(req.body)) {
        const sumStatus = (keyword, alertData) => isAlert(alertData) ? alertData.alerts.map(a => a[keyword]) : [];
        const statusStr = (keyword, alertData) => sumStatus(keyword, alertData).join(' ');
        const [hostnames, status] = ['hostname', 'status'].map(s => statusStr(s, req.body));
        node_notifier_1.default.notify({
            title: `${req.body.commonLabels.severity}: ${status} (${req.body.alerts.length}) ` +
                `"${req.body.commonLabels.alertname}" ${hostnames}`,
            message: util_1.inspect(req.body.alerts, false, 4)
        });
        console.log(moment().format(), util_1.inspect(req.body, false, 4));
        res.send('');
    }
    else {
        res.send("data doesn't have the right format");
    }
});
app.get('/', (req, res) => {
    res.send('GET requests are not supported, use POST instead');
});
app.listen(9099, () => console.log(`Alertmanager webhook receiver listening on port 9099`));
//# sourceMappingURL=index.js.map