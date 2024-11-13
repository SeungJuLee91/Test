# 취약한 오래된 이미지 기반 
FROM ubuntu:14.04

# 패키지를 설치할 때 최신 업데이트를 하지 않음
RUN apt-get install -y curl \
    && apt-get install -y wget

# 패키지를 서명 검증 없이 설치 (보안 취약점)
RUN apt-get install --allow-unauthenticated -y openssl

# 루트 권한으로 실행 (보안 모범 사례 위반)
CMD ["/bin/bash"]
