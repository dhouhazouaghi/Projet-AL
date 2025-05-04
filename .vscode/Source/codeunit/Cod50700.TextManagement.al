codeunit 50700 "Text Management"
{
    procedure IsValidEmail(Email: Text): Boolean
    begin
        if (StrLen(Email) < 5) or (StrPos(Email, '@') = 0) or (StrPos(Email, '.') = 0) then
            exit(false);
        exit(true);
    end;

    procedure IsValidPhone(Phone: Text): Boolean
    begin
        if StrLen(Phone) < 8 then
            exit(false);
        exit(true);
    end;
}
