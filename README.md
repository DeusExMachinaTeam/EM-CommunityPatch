<!-- Header -->
<div align="center">
  <a href="https://discord.gg/jZHxYdF">
    <img src="https://user-images.githubusercontent.com/79088546/174285554-cf467b80-7264-475f-94ec-bacc204b04c9.png" alt="Logo" width="400">
  </a>
  <h3 align="center">Комьюнити Ремастер / Комьюнити Патч</h3>

  <p align="center">
    Проект пользовательского ремастера / патча для игры Ex Machina.
    <br />
    <a href="https://discord.gg/jZHxYdF"><img src="https://user-images.githubusercontent.com/79088546/174305727-755adfa0-57c2-41b0-9717-8476fcbc4567.png" alt="Discord link"><strong>  Следить за разработкой в Discord »</strong></a>
    <br />
    <br />
    <a href="https://www.youtube.com/watch?v=rIkptWzmOqk"><img src="https://user-images.githubusercontent.com/79088546/174310152-da71224b-5c5f-4448-be42-31d0bc703360.png" alt="Youtube installation tutorial"> Как правильно установить</a>
    ·
    <a href="https://github.com/DeusExMachinaTeam/EM-CommunityPatch/issues" alt="Report bug on GitHub">Создать багрепорт</a>
    ·
    <a href="https://deuswiki.com/w/Community_Patch"><img src="https://user-images.githubusercontent.com/79088546/174311991-c20e04bb-1cad-44e2-a0e9-5984de6d8d55.png"> Страница на DeusWiki (только VPN)</a>
  </p>
</div>

<!-- About the project -->
# Про КомРем и КомПатч

![ComRem main menu Screen shot][screenshot_mainmenu]
*На скриншоте главное меню Комьюнити Ремастера*<br /><br />

&#128312;**Community Patch** - базовая версия, подходящая для играющих на ПК с 4:3 экранами и желающих получить максимально близкий к оригиналу опыт:
* повышает стабильность игры, существенно снижает число вылетов
* исправляет сюжетные ошибки, катсцены и квесты
* возвращает небольшое количество вырезанного "vanilla-friendly" контента
* улучшена физика авто, убрана "лунная гравитация"
* исправлен сломанный в оригинале широкий FOV
* исправлены ошибки моделей и анимаций

&#128992; **Community Remaster** - расширение Комьюнити Патча, идеален для ПК с широкоформатными экранами. Помимо всех исправлений КомПатча, так же:
* переработан интерфейс игры для адаптация под 16:9 разрешения
* добавлены новые, более качественные модели и анимации для части оружия и авто, больше красок для новых авто
* улучшена графика, шейдеры оригинала
* автором оригинального саундтрека записан ремастер части музыки

</br>

&#x1F53B; Важно! &#x1F53B;
* Установка Community Patch / Remaster возможно **только на no-DRM версию 1.02**! Это необходимо, потому как мы бинарно патчим exe игры, и все доступные изменения возможны только на 1.02. **Мы рекомендуем использовать русскую Steam версию для установки**. Другой вариант: распакованная версия с Антологии Ex Machina.
* Установка Community Patch / Remaster возможна **только на Windows 8, 10, 11 64bit**!

<p align="right">(<a href="#top">перейти наверх</a>)</p>

# Установка
![Do not use source code, download latest release][releases_screenshot]
## Видео-туториал
[Павлик RPG](https://www.youtube.com/channel/UCn4cTYbkGki7getrE5sZabw) записал подробное видео о том как установить КомПатч или КомРем, в виде по-умолчанию или с выбором опций, а так же о том как правильно репортить баги, ошибки и вылеты. [![youtube][youtube_logo_sml] Смотреть на YouTube](https://www.youtube.com/watch?v=rIkptWzmOqk)

## Простая установка
Однако, в целом ничего сложного в базовой установке нет.
Просто скопируйте файлы из скачанного релиза в папку с установленной игрой (версии 1.02 без DRM/защиты)

папки:
* libs
* patch
* remaster

и файл:
* **patcher.exe**
  
  
После этого запустите ![DeusExMachina logo][dem_logo_sml]  patcher.exe и следуйте инструкциям. Установка по-умолчанию возможна одним нажатием проблема в самом начале, такой вариант установит Community Remaster со всеми опциями.
<details>
<summary>Скриншот патчера во время работы</summary>

> ![Community Remaster installation][patcher_screenshot] 
> *Вступительный экран патчера, нажатие на Enter автоматически установит Community Remaster.*

</details>

</br>
&#x1F53B; Важно! &#x1F53B;
<ol>
**patcher.exe** - патчер программа, которая может вызывать ложные срабатывания анти-вирусов.
Патчер в процессе работы по-байтово патчит оригинальный exe игры, копирует файлы патча\ремастера в правильном порядке, а так же редактирует некоторые игровые файлы. К сожалению, как специфика работы (редактирование другого exe), так и то что патчер написан на Python, означает что вам может понадобиться добавить файл в исключения анти-вируса. Приносим свои извинения за неудобства.
</ol>
<p align="right">(<a href="#top">перейти наверх</a>)</p>

## Лицензирование:
<details>
<summary>Информация о лицензии</summary>

<ol>
Проект распространяется в полном виде только на Github.com.
Распространение полных файлов установки и результатов работы установщика Community Patch на других сайтах не разрешено.

Исходный код проекта(все файлы кроме patcher.exe) - лицензированы под MIT-подобной лицензией(исключая коммерческое использование) и может быть свободно использован как основа для создания ваших собственных модов. Пожалуйста, не забывайте сохранять текст лицензии и ссылку на проект, если используете его части.

Патчер Community Patch / Remaster распространяется под закрытой лицензией и может быть скачан только из Github репозитория команды DeusExMachinaTeam:
https://github.com/DeusExMachinaTeam/EM-CommunityPatch/

Для подробностей, пожалуйста, ознакомьтесь с полным текстом лицензии в файле LICENSE.
</ol>
</details>

# Скриншоты:
> ![Van and HD interface][van_screenshot]
*Новый Вэн, новый Корд, все элементы интерфейса отображаются в высоком качестве и не растянуты [HD машины, HD пушки - опции при установке КомРема]*

<br />

> ![ComRem main menu Screen shot][lorry_screenshot]
*Новый Молоковоз с дополнительной оранжевой раскраской, новый Спектр и Рейнметалл<br />[HD машины, HD пушки - опция при установке КомРема]"*

<br />

> ![ComRem main menu Screen shot][shop_interface]
*HD 16:9 интерфейс магазина и новые иконки товаров Комьюнити Ремастера*

<br />

> ![ComRem main menu Screen shot][cutscene_example]
*Вступительная катсцена, заметны корректный широкий FOV, качественная отрисовка шрифтов, портрет персонажа не растянут [КомРем]*

<br />

> ![ComRem main menu Screen shot][dialogue_interface]
*HD интерфейс диалогов, портрет персонажа теперь отображается в высоком разрешении [КомРем]* 

<br />

<a href="https://discord.gg/jZHxYdF"><img src="https://user-images.githubusercontent.com/79088546/174318753-aa4f938f-b7a5-49c0-b1cd-fc73b75080f7.png" width="350"/></a>
<a href="https://vk.com/em2ch"><img src="https://user-images.githubusercontent.com/79088546/174318046-57660bc9-010b-40d8-870d-0623b3fe57e2.png" alt="em2ch community logo" width="130"/></a>
<a href="https://www.youtube.com/c/rpggameland"><img src="https://user-images.githubusercontent.com/79088546/174320128-a8550d1c-2960-4aa1-8de6-8e414b2a8469.png" alt="em2ch community logo" width="130"/></a>

**Присоединяйтесь к нашим сообществам!**
<p align="right">(<a href="#top">перейти наверх</a>)</p>


<!-- Screenshot shortcuts -->
[screenshot_mainmenu]: https://user-images.githubusercontent.com/79088546/174288532-67106503-d79f-429f-9b28-c055fb1b0d51.jpg

[van_screenshot]:https://user-images.githubusercontent.com/79088546/174292723-5bf3f34b-4c75-4246-a24d-324d3b35d671.jpg

[lorry_screenshot]:https://user-images.githubusercontent.com/79088546/174292736-f51558e0-1a1e-4c9e-90e8-a707a1fb1ee7.jpg

[shop_interface]: https://user-images.githubusercontent.com/79088546/174293216-03fa560d-1204-4c7a-b947-65c4b59c1d46.jpg

[cutscene_example]: https://user-images.githubusercontent.com/79088546/174297723-d91c61c2-c240-4733-b195-88d84ad6c709.jpg

[dialogue_interface]: https://user-images.githubusercontent.com/79088546/174297984-78026b06-8d27-4ee4-aa71-25292a443d07.jpg

[discord_logo_sml]: https://user-images.githubusercontent.com/79088546/174304599-33630ab1-e5ce-4410-a720-55046783d085.png

[youtube_logo_sml]: https://user-images.githubusercontent.com/79088546/174310152-da71224b-5c5f-4448-be42-31d0bc703360.png

[dem_logo_sml]: https://user-images.githubusercontent.com/79088546/174311991-c20e04bb-1cad-44e2-a0e9-5984de6d8d55.png

[patcher_screenshot]: https://user-images.githubusercontent.com/79088546/174313893-ed72e5a4-4fff-4617-9610-e879f457c12d.png

[em2ch_logo]: https://user-images.githubusercontent.com/79088546/174318046-57660bc9-010b-40d8-870d-0623b3fe57e2.png

[releases_screenshot]: https://user-images.githubusercontent.com/79088546/174327479-67ac216d-d01a-4d0d-958b-aca2a141c5e4.png