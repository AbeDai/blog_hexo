{% if page.comments && theme.gitalk.enable %}

  <link rel="stylesheet" href="http://blog.daiyibo.cn/gitalk.css">

  <script src="https://unpkg.com/gitalk/dist/gitalk.min.js"></script>
  <script src="/js/src/md5.min.js"></script>

   <script type="text/javascript">
        var gitalk = new Gitalk({
          clientID: '{{ theme.gitalk.ClientID }}',
          clientSecret: '{{ theme.gitalk.ClientSecret }}',
          repo: '{{ theme.gitalk.repo }}',
          owner: '{{ theme.gitalk.owner }}',
          admin: ['{{ theme.gitalk.adminUser }}'],
          id: md5(location.pathname),
          labels: '{{ theme.gitalk.labels }}'.split(',').filter(l => l),
          perPage: {{ theme.gitalk.perPage }},
          pagerDirection: '{{ theme.gitalk.pagerDirection }}',
          createIssueManually: {{ theme.gitalk.createIssueManually }},
          distractionFreeMode: {{ theme.gitalk.distractionFreeMode }}
        })

        gitalk.render('gitalk-container')           
       </script>
{% endif %}