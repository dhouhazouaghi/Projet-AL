pageextension 50700 SocialMediaCard extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group("Social Media")
            {

                field(Facebook; Rec.Facebook) { ApplicationArea = All; }

                field(Instagram; Rec.Instagram) { ApplicationArea = All; }
                field(Linkedin; Rec.Linkedin) { ApplicationArea = All; }
                field(Twitter; Rec.Twitter) { ApplicationArea = All; }
                 usercontrol(ImageLabelControl; MyImageLabelAddin)
                {
                    ApplicationArea = All;
                    
                    trigger ControlAddInReady()
                    begin
                        CurrPage.ImageLabelControl.ReplaceLabelsWithImages();
                    end;
                }

                field(MyProgress; Rec.MyProgress)
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.bar.SetProgress(Rec.MyProgress);
                end;
            }
            usercontrol(bar; MyProgressBar)
            {
                ApplicationArea = All;
                trigger IAmReady()
                begin
                    CurrPage.bar.SetProgress(Rec.MyProgress);
                end;
            }
         }
       }
    }
    actions { }
}
