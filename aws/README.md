# AWS Terraform Modular Infrastructure

포트폴리오용으로 정리한 Terraform 기반 AWS 인프라 예제입니다.
과거 구축/검증 환경에서 사용한 구조를 기반으로 하며, 실제 운영 환경의 계정 정보나 Terraform state, 인증정보는 포함하지 않습니다.

## 구성 범위

- Multi-VPC 구조
  - `network-vpc`
  - `application-vpc`
  - `shared-vpc`
- AWS Transit Gateway 기반 VPC 간 연결
- Public / Private / Management Subnet 분리
- Internet Gateway / NAT Gateway / Route Table 구성
- EC2 및 Auto Scaling Group 구성
- Application Load Balancer / Listener / Target Group 구성
- Security Group 구성

## 디렉터리 구조

```text
.
├── network-vpc/
├── application-vpc/
├── shared-vpc/
└── modules/
    ├── auto_scaling_group/
    ├── ec2/
    ├── eip/
    ├── igw/
    ├── lb/
    ├── lb_listener_rule/
    ├── lb_target_group/
    ├── ngw/
    ├── route/
    ├── route_association/
    ├── route_table/
    ├── security_group/
    ├── subnet/
    ├── templates/
    ├── tgw/
    └── vpc/
```

Transit Gateway 관련 리소스는 attachment, route table, association, propagation, route 단위로 추가 분리했습니다.

## 주요 구현 내용

- 반복되는 AWS 리소스를 Terraform Module로 분리하여 재사용
- VPC별 구성을 별도 Root Module로 분리
- Transit Gateway를 중앙 라우팅 계층으로 사용
- 리소스 생성 순서가 필요한 구간에 명시적 module dependency 적용
- Application 영역에 ALB 및 Auto Scaling 구성
- AMI ID, EC2 Key Pair, Region 등 환경별 값을 변수로 분리
- HTTP/HTTPS와 관리자 접근(SSH/ICMP)의 허용 CIDR을 구분하여 Security Group 입력값으로 관리

## 공개용 코드 정리 사항

원본 구조와 Terraform 작성 흐름은 유지하면서 포트폴리오 공개에 맞게 아래 항목을 정리했습니다.

- 실제 AMI ID를 예제 값으로 변경
- EC2 Key Pair 이름을 예제 값으로 변경
- Region / AMI / Key Pair 값을 root variable로 분리
- SSH 및 ICMP의 `0.0.0.0/0` 허용을 제거하고 관리자 CIDR 입력값으로 분리
- `.tfstate`, `.tfvars`, private key, `.env` 등이 Git에 포함되지 않도록 `.gitignore` 적용

> 실제 운영 환경에서는 `admin_ingress_cidrs`, VPC CIDR, AMI, Key Pair, Region 등 모든 환경 값을 조직 정책에 맞게 별도로 설정해야 합니다.

## Security Note

이 저장소에는 다음 정보가 포함되지 않습니다.

- AWS Access Key / Secret Access Key
- Password / Token
- Terraform State
- Private Key
- 운영 환경용 tfvars

본 저장소는 실제 인프라 값을 재현하기 위한 목적이 아니라, Terraform을 활용한 AWS 인프라 모듈화 및 구성 경험을 보여주기 위한 포트폴리오 자료입니다.
