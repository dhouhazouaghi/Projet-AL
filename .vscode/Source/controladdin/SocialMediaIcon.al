controladdin MyImageLabelAddin
{
    RequestedHeight = 300;
    RequestedWidth = 500;
    VerticalStretch = true;
    HorizontalStretch = true;
    
    Scripts = 'main.js';
    
    event ControlAddInReady();
    procedure ReplaceLabelsWithImages();
}