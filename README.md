# Nutrient Scanner
종교, 알러지, 비건 등과 같은 이유로 식품 성분을 주의 깊게 살펴봐야하는 사용자를 대상으로, 식품의 뒷면 성분 정보를 촬영하면 주의해야할 식품 성분을 가이드해주는 앱입니다.<br/> 유저에게 실제 서비스 할 예정이며 실제 서비스 할 때에는 바코드를 먼저 스캔하도록 한 뒤, 바코드를 통해 DB에 해당 식품에 대한 정보가 있으면 그 정보를 먼저 제공하고, DB에 해당 식품에 대한 정보가 없는 경우에 식품 성분 정보를 촬영하도록 할 예정입니다.
<br/><br/><br/>

# 프로젝트 구조
- 촬영한 사진을 google_mlkit_text_recognition을 사용해서 내용을 텍스트로 읽어온 다음, 이 텍스트를 가지고 OpenAI API를 이용해 ChatGPT에게 성분 분석을 요청합니다.
- Feature-Based MVVM 패턴을 따릅니다.
```
  lib/
  └── features/
    └── nutrient_intake_guide/
        ├── model/
        ├── service/
        ├── view/guide_view.dart
        └── viewmodel/guide_viewmodel.dart
    └── nutrient_scanner/        
        ├── model/
            ├──recognized_text_model.dart
            └──cache_manager.dart
        ├── service/
        ├── view/scanner_view.dart
        └── viewmodel/scanner_viewmodel.dart
```
- 캐싱 레이어를 통해 단기간에 동일한 내용을 여러번 호출하지 않도록 구성하여 비용을 절감합니다.
<br/><br/>
![아키텍처 다이어그램](https://github.com/user-attachments/assets/5529884f-ffe9-4b5c-bf92-58e9257e6e71)
<br/><br/><br/>

# 브랜치 전략
프로젝트의 규모가 크지 않고, 혼자 개발을 진행하기 떄문에 **GitHub-Flow** 전략을 채택하였습니다.<br/>
GitHub-Flow는 GitHub에서 제안한 간단하고 유연한 브랜치 전략입니다.

- `main`: 항상 배포 가능한 상태.
- `feature/*`: 기능 개발 후 main으로 직접 병합 (Pull Request 검토 필수).

**장점:**
- **단순성**: 브랜치 구조가 단순하여 이해하고 적용하기 쉽습니다.
- **빠른 배포**: main에 병합되면 자동으로 배포되므로 지속적인 배포에 적합합니다.
- **효율적인 협업**: 풀 리퀘스트를 통한 코드 리뷰로 협업 효율을 높일 수 있습니다.

**단점:**
- **복잡한 릴리스 관리 어려움**: 여러 버전을 동시에 관리해야 하는 프로젝트에는 부적합할 수 있습니다.
- **긴급 수정 대응 어려움**: 별도의 hotfix 브랜치가 없으므로 긴급한 버그 수정 시 대응이 어려울 수 있습니다.
<br/><br/><br/>
