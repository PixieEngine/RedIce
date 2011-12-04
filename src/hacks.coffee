# Messing around with the global handler
window.onerror = (message, url, lineNumber) ->
  errorContext = $('script').last().text().split('\n')[(lineNumber-2)..(lineNumber+2)]

  displayRuntimeError?("#{message} on line #{lineNumber} of #{url}")

  displayRuntimeError?("Sometimes this context may be wrong. <br />" errorContext.join("<br />"))

