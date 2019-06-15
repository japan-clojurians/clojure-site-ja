<div class="clja-prev-next-container">
  <#if (content.prevpagehref)??><a href="${content.prevpagehref}" class="clja-prev-link"><span class="clja-prevnext-link-icon">←</span>&nbsp;${content.prevpagetitle}</a></#if>
  <#if (content.nextpagehref)??><a href="${content.nextpagehref}" class="clja-next-link">${content.nextpagetitle}&nbsp;<span class="clja-prevnext-link-icon">→</span></a></#if>
</div>
