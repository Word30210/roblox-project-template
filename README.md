# roblox-project-template
한국어 | [English](https://github.com/Word30210/roblox-project-template/blob/main/README-en_us.md)

여러 개의 플레이스를 활용하는 Roblox 프로젝트를 위한, 제 주관이 담긴 템플렛입니다.

> [!IMPORTANT]
> 이 저장소는 더 이상 관리되지 않으며, 공개 아카이브로 전환되었습니다.
> 대신 [roblox-project-example](https://github.com/Word30210/roblox-project-example) 저장소를 참고하세요.
>
> This repository is no longer maintained and has been archived.
> See [roblox-project-example](https://github.com/Word30210/roblox-project-example) instead.

> [!CAUTION]
> 이 문서는 업데이트 되지 않았습니다!
> 
> This document is outdated!

## 빠른 시작

mise가 설치되어 있어야 합니다.

```ps1
mise trust
mise install
just assets # asphalt sync studio
just install root-place-name # cd places/root-place-name; pesde install
just dev root-place-name # darklua process --watch, rojo sourcemap --watch, rojo serve 실행
```

## 사용 가이드

이 템플렛에서는 mise로 모든 툴을 관리하기 때문에 반드시 mise가 설치되어 있어야 합니다.
또한 모든 작업(rojo serve, darklua process, asphalt sync studio 등)은 just로 관리됩니다.

먼저, 이 템플렛을 가져오고 이름을 수정합니다.

```ps1
git clone https://github.com/Word30210/roblox-project-template.git
mv roblox-project-template your-project-name
cd your-project-name
rm -rf .git && git init
```

### 환경 변수 (.env)

이 템플릿은 `.env` 파일로 민감한 값을 관리합니다. `Justfile`이 `dotenv-load`를 켜두었기 때문에, `.env`에 정의한 값은 `just` 명령 실행 시 자동으로 불러와집니다.

`.env`는 API 키 같은 비밀 값을 담으므로 `.gitignore`에 포함되어 저장소에 커밋되지 않습니다. 대신 어떤 값이 필요한지 알려주는 `.env.example`이 함께 제공되니, 이를 복사해 자신의 값을 채워 넣으세요.

```ps1
cp .env.example .env
# 그런 다음 .env 를 열어 각 값을 채웁니다.
```

필요한 값은 다음과 같습니다.

- `ASPHALT_API_KEY`: `asphalt`가 에셋을 Roblox에 업로드(cloud sync)할 때 사용하는 API 키입니다. [Creator Dashboard](https://create.roblox.com/dashboard/credentials)에서 발급받을 수 있으며, `asset:read`와 `asset:write` 권한이 필요합니다. 로컬 Studio sync(`just assets`)만 사용할 때는 필요하지 않고, cloud 업로드 시에만 필요합니다.


### 사용하는 툴

- `mise`: 툴체인 매니저
- `rojo`: 파일 시스템의 코드를 Roblox Studio와 동기화 해주는 툴
- `stylua`: Lua 및 Luau를 대상으로 하는 코드 포메터
- `selene`: Lua 및 Luau를 대상으로 하는 코드 린터
- `pesde`: 패키지 매니저
- `asphalt`: 비코드 에셋 관리
- `lute`: Luau의 공식 독립 Luau 런타임
- `darklua`: Luau 코드를 변환해주는 도구(여기에서는 require 별칭을 Roblox 인스턴스 방식으로 변환)

### 구조 설명

- `packages/`: 프로젝트 내에 있는 플레이스들이 공통으로 사용 할 모듈들이 모여 있는 디렉터리입니다.
- `places/`: 프로젝트에 있는 플레이스 모노레포들이 모여 있는 디렉터리입니다.
- `assets/`: 프로젝트에서 쓰일 공통 에셋들이 모여 있는 디렉터리입니다.
- `mise.toml`: 프로젝트에서 쓰일 툴들을 관리하는 파일입니다.
- `asphalt.toml`: 비코드 에셋들을 관리해주는 툴인 `asphalt`의 설정 파일입니다.
- `pesde.toml`: 최상위 디렉터리에서 플레이스 및 공통 모듈 모노 레포들을 설정하는 파일입니다.
- `stylua.toml`: Luau 코드의 포메팅을 위한 설정 파일입니다.
- `.styluaignore`: `.gitignore`와 비슷하게 동작합니다. 일부 파일이나 디렉터리를 `StyLua` 포메터가 포메팅 하지 않게 하기 위한 설정 파일입니다.
- `selene.toml`: Luau 코드의 린팅을 위한 설정 파일입니다.
- `Justfile`: 자주 쓰이는 명령어 그룹을 모아놓은 파일입니다.

### 플레이스 만들고 개발 환경 세팅하기

새 플레이스는 `places/` 아래에 폴더를 하나 만드는 것으로 시작합니다. 최상위 `pesde.toml`의 `workspace_members`가 `places/*`를 포함하고 있어, `places/` 아래에 만든 폴더는 자동으로 워크스페이스 맴버로 인식됩니다.

가장 간단한 방법은 기존 플레이스(예: 템플렛에 포함된 예시 플레이스)를 복사한 뒤, 플레이스마다 고유한 값들만 수장하는 것입니다.

```ps1
# 기존 플레이스(템플렛의 lobby)를 복사해 새 플레이스를 만듭니다.
cp -r places/lobby places/your-place-name
```

복사한 뒤에는 다음 값들을 새 플레이스에 맞게 수정해야 합니다.

1. `places/your-place-name/pesde.toml`: 플레이스의 패키지 이름을 고유하게 바꿉니다.

   ```toml
   name = "your_scope/your-place-name"
   ```

2. `places/your-place-name/default.project.json` 와 `build.project.json`: 두 파일 모두 `name`과 `servePlaceIds`를 수정합니다. `name`은 플레이스 이름으로, `servePlaceIds`는 Roblox에서 이 플레이스에 해당하는 실제 Place ID로 바꿉니다.

   ```json
   {
       "name": "your-place-name",
       "servePlaceIds": [1234567890]
   }
   ```

3. `places/your-place-name/sourcemap.json` 와 `dist/`: 이 두 가지는 빌드 산출물이라 지워도 됩니다. 이후 `just` 명령이 다시 생성합니다.

   ```ps1
   Remove-Item -Recurse -Force places/your-place-name/sourcemap.json, places/your-place-name/dist -ErrorAction SilentlyContinue
   ```

   혹은

   ```ps1
   just clean your-place-name
   ```

수정을 마쳤으면 패키지를 설치하고 개발을 시작합니다.

```ps1
# 공통 모듈(shared 등)을 이 플레이스에 링크합니다.
# packages/ 아래의 공통 모듈을 수정한 뒤에도 다시 실행해야 반영됩니다.
just install your-place-name

# 개발 모드 실행: sourcemap watch + darklua watch + rojo serve 를 병렬로 띄웁니다.
just dev your-place-name
```

`just dev`를 실행하면 다음이 동시에 돌아갑니다.

- `rojo sourcemap --watch`: 자동완성용 소스맵을 원본 코드 기준으로 생성·감시합니다.
- `darklua process --watch`: `require("@shared")` 같은 별칭 require를 Roblox 인스턴스 방식으로 변환해 `dist/`에 출력합니다.
- `rojo serve`: 변환된 `dist/`를 Roblox Studio에 동기화합니다.

이후 Roblox Studio에서 Rojo 플러그인으로 연결하면 개발을 시작할 수 있습니다.

> 개발 환경을 위한 소스맵은 원본 코드 기준(`default.project.json`)으로 생성되고, Studio에 실제로 동기화되는 것은 darklua로 변환된 `dist`(`build.project.json`) 기준입니다. 편집·타입체크용과 실행용을 분리해 순환 참조 문제를 피하는 구조입니다.

### 에셋 추가하기

공통 에셋은 최상위 `assets/` 디렉터리에 넣습니다. `asphalt`가 이를 업로드하고, 참조 코드를 공통 모듈에 생성해 모든 플레이스에서 쓸 수 있게 합니다.

```ps1
# 에셋을 Roblox Studio에 로컬로 sync (개발/테스트용)
just assets

# 에셋을 추가/변경한 뒤에는 공통 모듈을 다시 링크해야 각 플레이스에 반영됩니다.
just install your-place-name
```

## 로드맵

아직 지원하지 않는 기능입니다.

- CI/CD(StyLua, Selene)
