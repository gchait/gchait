#!/usr/bin/env python3

from itertools import islice
from subprocess import run
from tempfile import NamedTemporaryFile
from time import sleep
from typing import NamedTuple

import kubernetes.client
import kubernetes.config
import prometheus_client


class Vulnerability(NamedTuple):
    image: str
    package_name: str
    package_type: str
    installed_ver: str
    fixed_ver: str
    vuln_id: str
    vuln_severity: str


def update_vuln_metrics(vulns: list[Vulnerability]) -> None:
    for vuln in vulns:
        vuln_metric.labels(*vuln).set(1)


def run_grype(image: str) -> list[Vulnerability]:
    vulns = []
    command = ["grype", "--only-fixed", "-qo", "template", "-t", grype_tmpl, image]
    result = run(command, capture_output=True, text=True)
    if result.returncode == 0:
        result_text = result.stdout.strip()
        if result_text:
            for entry in result_text.split("\n"):
                vulns.append(Vulnerability(image, *entry.split(" ; ")))
    return vulns


def get_all_images() -> set[str]:
    images = set()
    ret = v1.list_pod_for_all_namespaces()
    for i in ret.items:
        if i.spec.init_containers:
            for j in i.spec.init_containers:
                images.add(j.image)
        for l in i.spec.containers:
            images.add(l.image)
    return images


def create_grype_tmpl() -> str:
    grype_tmlp_tmp_file = NamedTemporaryFile(delete=False)
    grype_tmpl_contents = (
        "{{- range .Matches }}\n"
        "{{ .Artifact.Name }} ; "
        "{{ .Artifact.Type }} ; "
        "{{ .Artifact.Version }} ; "
        "{{ index .Vulnerability.Fix.Versions 0 }} ; "
        "{{ .Vulnerability.ID }} ; "
        "{{ .Vulnerability.Severity }}\n"
        "{{- end }}"
    )
    with open(grype_tmlp_tmp_file.name, "w", encoding="utf-8") as f:
        f.write(grype_tmpl_contents)
    print(grype_tmlp_tmp_file.name)
    return grype_tmlp_tmp_file.name


def process_vulns():
    images = get_all_images()
    for image in islice(images, 5):  # temp islice for testing
        print(f"{image=}")
        vulns = run_grype(image)
        print(f"{vulns=}")
        if vulns:
            update_vuln_metrics(vulns)


if __name__ == "__main__":
    grype_tmpl = create_grype_tmpl()
    labels = Vulnerability._fields

    prometheus_client.start_http_server(9000)
    vuln_metric = prometheus_client.Gauge(
        "vulnerability",
        "A Grype-found vulnerability in a package within a container image.",
        labels,
    )

    kubernetes.config.load_kube_config()
    v1 = kubernetes.client.CoreV1Api()

    while True:
        process_vulns()
        sleep(60)
