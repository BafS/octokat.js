define = window?.define or (deps, cb) -> cb((require(dep.replace('cs!', '')) for dep in deps)...)
define ['chai', 'cs!./test-config'], ({assert, expect}, {client, REPO_USER, REPO_NAME}) ->

  describe 'URL Hypermedia Patterns', ->

    it 'supports hypermedia URLs with optional URL and querystring params', ->
      template = '/repos/{repoName}{/user}{/foo}/releases/1/assets{?name,title,label}'
      expected = '/repos/AAA/BBB/releases/1/assets?name=CCC&label=DDD'
      params =
        repoName: 'AAA'
        user: 'BBB'
        name: 'CCC'
        label: 'DDD'
      {url} = client.fromUrl(template, params)
      expect(url).to.equal(expected)

    it 'supports hypermedia URLs with missing querystring params', ->
      template = '/repos{?label,title}'
      expected = '/repos'
      params = {}
      {url} = client.fromUrl(template, params)
      expect(url).to.equal(expected)


    it 'supports fetching from a hypermedia-constructed URL', (done) ->
      template = '/repos/{repoUser}{/repoName}'
      params =
        repoUser: REPO_USER
        repoName: REPO_NAME
      client.fromUrl(template, params).fetch()
      .then (repo) ->
        expect(repo.name).to.equal(REPO_NAME)
        done()

  # describe 'URL Hypermedia Patterns (only tested in Node)', ->
  #
  #   URL_PATTERN = 'https://foo{?name,label}'
  #   CONTENT_TYPE = 'application/javascript'
  #   CONTENT = 'js_contents()'
  #
  #   it 'supports a single optional arg', (done) ->
  #     EXPECTED_URL = 'https://foo?name=build.js'
  #     requestFn = (method, url, content, {contentType, raw}) ->
  #       expect(url).to.equal(EXPECTED_URL)
  #       expect(content).to.equal(CONTENT)
  #       expect(contentType).to.equal(CONTENT_TYPE)
  #       expect(raw).to.be.true
  #       done()
  #     data = {upload_url: URL_PATTERN}
  #     {data} = HYPERMEDIA.responseMiddleware({requestFn, data})
  #     data.upload('build.js', CONTENT_TYPE, CONTENT)
  #
  #   it 'supports a single optional arg which is not a string', (done) ->
  #     EXPECTED_URL = 'https://foo?name=1234'
  #     requestFn = (method, url, content, {contentType, raw}) ->
  #       expect(url).to.equal(EXPECTED_URL)
  #       expect(content).to.equal(CONTENT)
  #       expect(contentType).to.equal(CONTENT_TYPE)
  #       expect(raw).to.be.true
  #       done()
  #     data = {upload_url: URL_PATTERN}
  #     {data} = HYPERMEDIA.responseMiddleware({requestFn, data})
  #     data.upload(1234, CONTENT_TYPE, CONTENT)
  #
  #   it 'supports multiple optional args', (done) ->
  #     EXPECTED_URL = 'https://foo?name=build.js&label=MY%20LABEL'
  #     requestFn = (method, url, content, {contentType, raw}) ->
  #       expect(url).to.equal(EXPECTED_URL)
  #       expect(content).to.equal(CONTENT)
  #       expect(contentType).to.equal(CONTENT_TYPE)
  #       expect(raw).to.be.true
  #       done()
  #     data = {upload_url: URL_PATTERN}
  #     {data} = HYPERMEDIA.responseMiddleware({requestFn, data})
  #     data.upload({name: 'build.js', label: 'MY LABEL'}, CONTENT_TYPE, CONTENT)
