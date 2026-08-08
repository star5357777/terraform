# Terraform Multi-Cloud Infrastructure Portfolio

Terraform을 활용하여 AWS를 중심으로 클라우드 인프라를 코드화하고, Azure 및 NCP 환경에도 IaC 방식을 적용했던 경험을 정리한 포트폴리오 저장소입니다.

## Cloud별 구성 범위

| Cloud | 주요 구성 | 포트폴리오 내 비중 |
| --- | --- | --- |
| **AWS** | Multi-VPC, Transit Gateway, ALB, Auto Scaling, EC2, NAT Gateway, Security Group | Main |
| **Azure** | Resource Group, VNet, Subnet, Route Table, NSG, NIC, Virtual Machine | Supplementary |
| **NCP** | VPC, Subnet, NAT Gateway, ACG, Server, Network ACL | Supplementary |

## Repository Structure

```text
.
├── aws/      # AWS 중심 Terraform 인프라 구성
├── azure/    # Azure Terraform 구성 경험
└── ncp/      # NCP Terraform 구성 경험
```

## AWS

가장 범위가 큰 Terraform 코드입니다. VPC를 역할별로 분리하고 Transit Gateway를 통한 연결 구조, ALB/Auto Scaling, EC2, NAT Gateway 및 Security Group 등을 Terraform Module로 구성했습니다.

- Multi-VPC: `network-vpc`, `application-vpc`, `shared-vpc`
- Transit Gateway 및 Route Table / Association / Propagation
- Public / Private Subnet 및 NAT Gateway
- ALB / Target Group / Listener
- Auto Scaling Group / EC2
- 반복 리소스의 Terraform Module 분리

자세한 내용은 [`aws/README.md`](./aws/README.md)를 참고하세요.

## Azure

Azure 환경에서 네트워크 및 VM 관련 자원을 Terraform Module 단위로 구성했던 코드입니다.

- Resource Group
- VNet / Public·Private Subnet
- Route Table / Route / Association
- Public IP / NIC
- NSG / Security Rule
- Linux Virtual Machine

자세한 내용은 [`azure/README.md`](./azure/README.md)를 참고하세요.

## NCP

Naver Cloud Platform 환경에서 VPC 기반 네트워크 및 서버 자원을 Terraform으로 구성했던 코드입니다. 원본 백업에 일부 참조 모듈 구현 파일이 남아 있지 않아 현재 확인 가능한 코드만 공개합니다.

- VPC / Public·Private Subnet
- Network ACL
- NAT Gateway
- Route / Route Association
- ACG / ACG Rule
- Network Interface / Server

자세한 내용과 백업 범위는 [`ncp/README.md`](./ncp/README.md)를 참고하세요.

## Security

공개 저장소용으로 실제 인증정보, 비밀번호, Terraform state, private key 및 환경별 tfvars는 제외했습니다. SSH 관리자 접근 대역과 환경 종속 값은 가능한 범위에서 변수로 분리했습니다.

이 저장소는 세 클라우드에 대한 동일 수준의 전문성을 주장하기 위한 자료가 아니라, **AWS 중심의 Terraform/IaC 경험과 Azure/NCP 환경으로의 적용 경험을 실제 코드로 보여주기 위한 포트폴리오 자료**입니다.
