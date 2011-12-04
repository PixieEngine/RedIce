# Messing around with the global handler
window.onerror = (message, url, lineNumber) ->
  errorContext = $('script').last().text().split('\n')[(lineNumber-5)..(lineNumber+4)]

  errorContext[4] = "<b style='font-weight: bold; text-decoration: underline;'>" + errorContext[4] + "</b>"

  displayRuntimeError?("<code>#{message}</code> <br /><br />(Sometimes this context may be wrong.)<br /><code><pre>#{errorContext.join('\n')}</pre></code>")

