# NCP Terraform Infrastructure

Naver Cloud Platform(NCP) 환경에서 Terraform을 활용해 VPC 기반 네트워크와 서버 자원을 구성했던 코드의 공개용 정리본입니다.

이 저장소는 과거 구축/검증 과정에서 보관된 코드 중 현재 확인 가능한 부분을 기준으로 정리했습니다.  
AWS 포트폴리오 코드보다 범위가 작고, 원본 백업에 일부 참조 모듈의 구현 파일이 남아 있지 않아 **현재 상태 그대로 전체 배포가 가능한 완성형 예제는 아닙니다.**

## 확인 가능한 구성

- NCP VPC
- Public / Private Subnet
- Network ACL
- NAT Gateway
- Public / Private Route Table 및 Route 연결 구조
- Access Control Group(ACG) 및 Inbound/Outbound Rule
- Network Interface
- Public / Private Server
- Public IP 연결 구조
- NCP Server Image / Product Data Source 조회
- 각 리소스를 재사용 가능한 Terraform Module 단위로 분리

## 코드에서 확인되는 네트워크 구조

```text
VPC 10.0.0.0/16
├── Public Subnet
│   ├── 10.0.0.0/24 (KR-1)
│   └── 10.0.1.0/24 (KR-2)
└── Private Subnet
    ├── 10.0.2.0/24 (KR-1)
    └── 10.0.3.0/24 (KR-2)

Private Route -> NAT Gateway
Public Server -> Public Subnet
Private Server -> Private Subnet
```

CIDR과 서버 Private IP는 공개용 예시값이며 `variables.tf`에서 변경할 수 있도록 정리했습니다.

## 공개용 정리 사항

- macOS 메타데이터(`.DS_Store`, `__MACOSX`) 제거
- Login Key 이름을 예제값으로 변경하고 변수화
- VPC/Subnet CIDR, 서버 Private IP, Availability Zone을 변수화
- SSH(22) 접근의 `0.0.0.0/0` 허용을 제거하고 관리자 CIDR 변수로 분리
- HTTP/HTTPS 공개 접근과 outbound 구조는 원본 의도를 유지
- `.tfstate`, `.tfvars`, key, `.env` 등 민감 파일을 `.gitignore`로 제외

## 원본 백업에서 확인되지 않은 구현 파일

현재 전달받은 백업에는 `main.tf`에서 참조하는 아래 모듈의 일부 구현 파일이 존재하지 않습니다.

- `modules/route_table`
- `modules/public_ip`
- `modules/route/main.tf`
- `modules/network_interface/main.tf`
- `modules/vpc/main.tf`

따라서 이 저장소는 실행 가능한 샘플을 새로 만들어 보완하지 않고, **실제로 남아 있는 코드 범위만 공개**합니다.  
포트폴리오에서는 “NCP에서도 Terraform을 활용해 VPC, Subnet, NAT Gateway, ACG, Server 등 인프라 자원을 모듈화하여 구성한 경험”의 근거 자료로 사용하는 것이 적절합니다.

## Security Note

실제 Access Key / Secret Key, Terraform State, tfvars, Private Key는 포함하지 않습니다.  
NCP Provider 인증정보는 코드에 하드코딩하지 않고 실행 환경의 안전한 인증 방식으로 주입해야 합니다.
