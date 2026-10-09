// Load workspace.json and create color legend
fetch('./workspace.json')
  .then(response => response.json())
  .then(data => {
    const styles = data.views.configuration.styles.elements;
    const legendItems = document.getElementById('color-legend');
    
    styles.forEach(({ tag, background }) => {
      if (tag && background) {
        legendItems.innerHTML += `
          <div class="legend-item">
            <div class="legend-color" style="background-color: ${background};"></div>
            <span class="legend-label">${tag}</span>
          </div>
        `;
      }
    });
  })
  .catch(error => console.error('Error loading workspace.json:', error));