function cickBtn(btn){
    const btn1=document.getElementById("btnStandard");
    const btn2=document.getElementById("btnMetric");
    btn.style.color = 'red';
        if (btn === btn1) {
        btn2.style.color = 'black';
        
    } else {
        btn1.style.color = 'black';
    }
}
