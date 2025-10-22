
function global:clic{
    param()
    $MouseEventSig=@' 
[DllImport("user32.dll",CharSet=CharSet.Auto, CallingConvention=CallingConvention.StdCall)]
public static extern void mouse_event(long dwFlags, long dx, long dy, long cButtons, long dwExtraInfo);
'@ 
$MouseEvent = Add-Type -memberDefinition $MouseEventSig -name "MouseEventWinApi" -passThru

    $MouseEvent::mouse_event(0x00000002, 0, 0, 0, 0)
    $MouseEvent::mouse_event(0x00000004, 0, 0, 0, 0)
    return $null
}
function global:JustClic {
    param($cpt=0)
    while ($cpt -gt 0){
        clic ; start-sleep -Milliseconds 100
        $cpt--
    }
    return $null
}
