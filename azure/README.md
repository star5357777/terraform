# Azure Terraform Modular Infrastructure

포트폴리오 공개를 위해 정리한 Terraform 기반 Microsoft Azure 인프라 예제입니다.
과거 구축/학습 환경에서 작성한 코드를 기반으로 하며 실제 계정 인증정보, Terraform state, 비밀번호는 포함하지 않습니다.

## 구성 범위

- Azure Resource Group
- Virtual Network 및 Public / Private Subnet
- Route Table / Route / Subnet Association
- Public IP 및 Network Interface
- Network Security Group / Security Rule
- Linux Virtual Machine
- NIC와 NSG 연결

## 디렉터리 구조

```text
.
├── vpc/
│   ├── main.tf
│   └── variables.tf
└── modules/
    ├── resource_group/
    ├── virtual_network/
    ├── subnet/
    ├── route_table/
    ├── route/
    ├── route_association/
    ├── public_ip/
    ├── network_interface/
    ├── network_security_group/
    ├── network_security_rule/
    ├── network_interface_security_group_association/
    └── virtual_machine/
```

## 주요 구현 내용

- 반복되는 Azure 리소스를 Terraform Module로 분리
- VNet 내 Public / Private Subnet 분리
- Route Table 및 Subnet Association 구성
- Public IP, NIC, NSG, Security Rule을 개별 모듈로 구성
- NIC와 NSG 연동 후 Linux VM 배포 구조 구성
- VM 관리자 비밀번호를 코드에서 제거하고 `sensitive` 입력 변수로 분리
- SSH 접근 CIDR을 별도 입력값으로 분리하여 전체 공개 접근 제거

## 공개용 코드 정리 사항

원본 Terraform 구성 흐름은 유지하면서 공개 저장소에 적합하도록 다음 항목을 정리했습니다.

- 평문 VM 관리자 비밀번호 제거
- 관리자 비밀번호를 `sensitive` Terraform 변수로 변경
- SSH(22) 소스 대역을 `admin_ingress_cidr` 변수로 분리
- `.tfstate`, `.tfvars`, private key 및 환경파일을 `.gitignore` 처리
- `.DS_Store`, swap 파일 등 로컬 작업 파일 제거

> 이 저장소는 현재 Azure 권장 아키텍처를 제시하기 위한 샘플이 아니라, Terraform을 활용해 Azure 리소스를 모듈화하고 구성했던 경험을 보여주기 위한 포트폴리오 자료입니다.

## Security Note

실행 시 `vm_admin_password` 값은 환경에 맞게 안전하게 주입해야 하며, 실제 비밀번호가 포함된 `tfvars` 파일은 Git에 커밋하지 않아야 합니다.
