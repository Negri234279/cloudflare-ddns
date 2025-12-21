## [1.6.1](https://github.com/Negri234279/cloudflare-ddns/compare/v1.6.0...v1.6.1) (2025-12-21)


### Bug Fixes

* add comment to ARG ci ([2666730](https://github.com/Negri234279/cloudflare-ddns/commit/2666730c60d2723bff78e9d68680fc9b4619aa9b))
* addgroup: group 'ddns' in use ([8ce33e1](https://github.com/Negri234279/cloudflare-ddns/commit/8ce33e1a6ef346c49d3dbdebbd80f0b29a150d68))

# [1.6.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.5.0...v1.6.0) (2025-12-21)


### Bug Fixes

* eliminar la configuración del driver local para el volumen cloudflare-ddns-data ([6b21804](https://github.com/Negri234279/cloudflare-ddns/commit/6b21804459da6b750a642c5758b585f398b38bed))


### Features

* agregar persistencia de estado y mejorar la gestión de volúmenes en Docker ([c0958c1](https://github.com/Negri234279/cloudflare-ddns/commit/c0958c1204bba1d7f6940712ec0bb200021c16b4))

# [1.5.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.4.1...v1.5.0) (2025-12-20)


### Features

* agregar variable APP_VERSION al entorno y actualizar su uso en entrypoint.sh ([46ac505](https://github.com/Negri234279/cloudflare-ddns/commit/46ac505566ef423a94733c366ac0eb5aad84e6fc))

## [1.4.1](https://github.com/Negri234279/cloudflare-ddns/compare/v1.4.0...v1.4.1) (2025-12-18)


### Bug Fixes

* eliminar la impresión de la respuesta de la API en el script de actualización de DNS ([3d842c7](https://github.com/Negri234279/cloudflare-ddns/commit/3d842c7238027174359ef46bb7dd4755324f90e3))

# [1.4.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.3.1...v1.4.0) (2025-12-18)


### Features

* agregar argumentos de construcción y metadatos a la imagen Docker ([057ce7e](https://github.com/Negri234279/cloudflare-ddns/commit/057ce7e9480b5795861464be1be62ca5419e641d))

## [1.3.1](https://github.com/Negri234279/cloudflare-ddns/compare/v1.3.0...v1.3.1) (2025-12-18)


### Bug Fixes

* agregar nueva línea al final del archivo README.md ([e99d1e4](https://github.com/Negri234279/cloudflare-ddns/commit/e99d1e42c7a81b1bb3caaef650a96345323b198d))
* corregir traducciones y mejorar la claridad del README.md ([6ff2b25](https://github.com/Negri234279/cloudflare-ddns/commit/6ff2b2532aac9720d5477eae287fbb8d1c832960))

# [1.3.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.2.0...v1.3.0) (2025-12-18)


### Features

* actualizar .gitignore para incluir nuevas reglas de exclusión ([fbc24e8](https://github.com/Negri234279/cloudflare-ddns/commit/fbc24e89060e0ec6bb0ac621e81bf152b1983c50))
* agregar archivo docker-compose.dev.yml para configuración de desarrollo ([4b386b0](https://github.com/Negri234279/cloudflare-ddns/commit/4b386b0cd975a2eed18d398784d4e33d9462a68b))
* agregar recuperación automática del ID de registro DNS en el script de actualización ([79a188c](https://github.com/Negri234279/cloudflare-ddns/commit/79a188c21891ff8e5a96002e6ebceb4a0be08833))
* agregar reglas de longitud máxima del encabezado en commitlint ([689f456](https://github.com/Negri234279/cloudflare-ddns/commit/689f45660e87d14c206c659eb8997150013b09d7))
* agregar soporte para tipo de registro DNS configurable en el script de actualización y documentación ([d9b63b6](https://github.com/Negri234279/cloudflare-ddns/commit/d9b63b622a35253c3fe6dfc5b8d430695ccaf80e))

# [1.2.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.1.0...v1.2.0) (2025-12-17)


### Features

* agregar ruta del README.md en la actualización de la descripción de Docker Hub ([6e1f28f](https://github.com/Negri234279/cloudflare-ddns/commit/6e1f28fd80f256e38bb9289220577ed218712ad9))

# [1.1.0](https://github.com/Negri234279/cloudflare-ddns/compare/v1.0.2...v1.1.0) (2025-12-17)


### Features

* agregar README.md con información del proyecto y uso ([36a93d3](https://github.com/Negri234279/cloudflare-ddns/commit/36a93d365f6febae223279cce1ede41699a7e306))

## [1.0.2](https://github.com/Negri234279/cloudflare-ddns/compare/v1.0.1...v1.0.2) (2025-12-17)


### Bug Fixes

* agregar actualización de descripción en Docker Hub ([f2ca1db](https://github.com/Negri234279/cloudflare-ddns/commit/f2ca1dbac8ef9d1cac03e278cb038bf917f6581f))

## [1.0.1](https://github.com/Negri234279/cloudflare-ddns/compare/v1.0.0...v1.0.1) (2025-12-17)


### Bug Fixes

* actualizar la referencia del propietario en las etiquetas de GHCR ([1db7f82](https://github.com/Negri234279/cloudflare-ddns/commit/1db7f8223010320fa3b3648b9a99837cd4b67388))
* corregir la referencia al propietario del repositorio en las etiquetas de Docker ([4a36bd0](https://github.com/Negri234279/cloudflare-ddns/commit/4a36bd085fb96945c2e1aaf61e3fe26a78a3695e))

# 1.0.0 (2025-12-17)


### Bug Fixes

* ajustar permisos en el flujo de trabajo de lanzamiento y Docker ([870eeb9](https://github.com/Negri234279/cloudflare-ddns/commit/870eeb9f1fe64c9452658fb267b750f3197e1e32))


### Features

* add script for cloudflare ddns ([464d71d](https://github.com/Negri234279/cloudflare-ddns/commit/464d71dc9d297619f08a10eeef01c159964f226e))
