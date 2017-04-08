	<!-- Fixed navbar -->
    <div class="navbar navbar-default navbar-fixed-top" role="navigation">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>">Clojure</a>
        </div>
        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>about/rationale.html">概要</a></li>
            <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>reference/documentation">リファレンス</a></li>
            <!-- <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>api/api.html">API</a></li>
              <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>community/downloads.html">リリース</a></li>
              <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>guides/guides.html">ガイド</a></li>
              <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>community/resources.html">コミュニティ</a></li>
              <li><a href="<#if (content.rootpath)??>${content.rootpath}<#else></#if>news/news.html">ニュース</a></li>
              <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
              <ul class="dropdown-menu">
              <li><a href="#">Action</a></li>
              <li><a href="#">Another action</a></li>
              <li><a href="#">Something else here</a></li>
              <li class="divider"></li>
              <li class="dropdown-header">Nav header</li>
              <li><a href="#">Separated link</a></li>
              <li><a href="#">One more separated link</a></li>
              </ul>
              </li> -->
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </div>
    <div class="container">
