#!/bin/bash

function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.json
}

function yaml_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORG}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        organizations/ccp-template.yaml | sed -e $'s/\\\\n/\\\n          /g'
}

ORG=InsuranceCompany1
P0PORT=7051
CAPORT=7054
PEERPEM=organizations/peerOrganizations/InsuranceCompany1.example.com/tlsca/tlsca.InsuranceCompany1.example.com-cert.pem
CAPEM=organizations/peerOrganizations/InsuranceCompany1.example.com/ca/ca.InsuranceCompany1.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/InsuranceCompany1.example.com/connection-InsuranceCompany1.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/InsuranceCompany1.example.com/connection-InsuranceCompany1.yaml

ORG=InsuranceCompany1
P0PORT=9051
CAPORT=8054
PEERPEM=organizations/peerOrganizations/InsuranceCompany2.example.com/tlsca/tlsca.InsuranceCompany2.example.com-cert.pem
CAPEM=organizations/peerOrganizations/InsuranceCompany2.example.com/ca/ca.InsuranceCompany2.example.com-cert.pem

echo "$(json_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/InsuranceCompany2.example.com/connection-InsuranceCompany2.json
echo "$(yaml_ccp $ORG $P0PORT $CAPORT $PEERPEM $CAPEM)" > organizations/peerOrganizations/InsuranceCompany2.example.com/connection-InsuranceCompany2.yaml
