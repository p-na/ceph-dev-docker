FROM grafana/grafana:6.7.4

ADD grafana.ini /etc/grafana/grafana.ini
ADD ceph-dashboards.yml /etc/grafana/provisioning/dashboards/ceph-dashboards.yaml
ADD datasource.yml /etc/grafana/provisioning/datasources/datasource.yaml

RUN grafana-cli plugins install vonage-status-panel && \
    grafana-cli plugins install grafana-piechart-panel

