window.addEventListener("load", function() {
  Scheme.load_main("main.wasm", {
    user_imports: {
      document: {
        body() { return document.body; },
          createTextNode: Document.prototype.createTextNode.bind(document),
          getElementById: (id) => document.getElementById(id)
      },
      element: {
          appendChild(parent, child) { return parent.appendChild(child); },
          setHtml(elem, html) { elem.innerHTML = html; },
          addEventListener(elem, name, f) { elem.addEventListener(name, f); },
          appendHtml(elem, html) { elem.innerHTML += html; }
      }
    }
  });
});
