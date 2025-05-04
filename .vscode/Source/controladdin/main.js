// MyImageLabelAddin.js
class MyImageLabelAddin {
    constructor() {
        this.control = null;
    }

    init(control) {
        this.control = control;
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ControlAddInReady', []);
    }

    ReplaceLabelsWithImages() {
        try {
            // Récupérer les éléments de la page
            const fields = document.querySelectorAll('.control-field');
            
            fields.forEach(field => {
                const label = field.querySelector('label');
                if (label) {
                    const socialMedia = label.textContent.toLowerCase();
                    let imageUrl = '';

                    // Assigner les URLs des images selon le réseau social
                    switch(socialMedia) {
                        case 'facebook':
                            imageUrl = 'https://example.com/facebook.png';
                            break;
                        case 'instagram':
                            imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png';
                            break;
                        case 'linkedin':
                            imageUrl = 'https://example.com/linkedin.png';
                            break;
                        case 'twitter':
                            imageUrl = 'https://example.com/twitter.png';
                            break;
                    }

                    if (imageUrl) {
                        const img = document.createElement('img');
                        img.src = imageUrl;
                        img.style.width = '24px';
                        img.style.height = '24px';
                        img.style.marginRight = '5px';
                        label.insertBefore(img, label.firstChild);
                    }
                }
            });
        } catch (error) {
            console.error('Error in ReplaceLabelsWithImages:', error);
        }
    }
}

// Register the control add-in
Microsoft.Dynamics.NAV.RegisterControlAddIn('MyImageLabelAddin', MyImageLabelAddin);