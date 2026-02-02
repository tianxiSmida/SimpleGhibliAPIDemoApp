# Ghibli Simple API Info Demo

專案配置:
- 系統：iOS 18.4+
- 架構：MVVMC
- 框架：RxSwift
- 網路層：Moya

API [documentation](https://ghibliapi.vercel.app/) for Studio Ghibli:
- base URL: https://ghibliapi.vercel.app/
- endpoints: `/films`,  `/people`
- no authentication required

[流程圖](./FlowChart.md)

## Features of the Reference Project

- TabView with Navigation Stacks
- List Screen (fetch from API, show list of items).
- Detail Screen (display more info, async image loading).
  
<p float="left">
  <img src="./Images/ghibli_movie.jpg" width="30%" />
  <img src="./Images/ghibli_detail.jpg" width="30%" /> 
</p>

- Favorites (local persistence).
  
<img src="./Images/ghibli_favorite.jpg" width=30%>

- Settings (theme, stored in UserDefaults).
  
<p float="left">
<img src="./Images/ghibli_settings.jpg" width=30%>
<img src="./Images/ghibli_settings_light.jpg" width=30%>
</p>

# Reference
⭐️⭐️⭐️⭐️⭐️ [GhibliSwiftUIApp](https://github.com/gahntpo/GhibliSwiftUIApp) by [Karin Prater](https://github.com/gahntpo)