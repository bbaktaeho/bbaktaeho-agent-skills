/* Mermaid initialization for blockchain-research report HTML.
 *
 * Loaded after the Mermaid CDN script. Keeps theme consistent with the
 * monochrome report style and avoids diagrams colored outside the report
 * palette.
 */
(function () {
  if (typeof window === "undefined" || !window.mermaid) return;
  window.mermaid.initialize({
    startOnLoad: true,
    theme: "neutral",
    securityLevel: "loose",
    themeVariables: {
      fontFamily: "-apple-system, 'Noto Sans KR', sans-serif",
      primaryColor: "#ffffff",
      primaryTextColor: "#111111",
      primaryBorderColor: "#111111",
      lineColor: "#333333",
      secondaryColor: "#fafafa",
      tertiaryColor: "#f4f4f4"
    },
    flowchart: { htmlLabels: true, curve: "basis" },
    sequence: { actorMargin: 50, noteMargin: 10 }
  });
})();
