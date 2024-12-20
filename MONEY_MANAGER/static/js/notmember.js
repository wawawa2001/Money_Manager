function show_detail(e) {
    var elem = e.target;
    document.getElementById("detail_table").style.display = "table"
    
    title = document.getElementById("title")
    from = document.getElementById("from")
    time = document.getElementById("time")
    maintext = document.getElementById("maintext")

    if (e.tagName && e.tagName.toLowerCase() === 'p') {
        elem = target.closest('td');
    }else{
        elems = elem.parentElement.parentElement
    }

    elems = elems.getElementsByTagName("td")

    title.innerText = elems[1].innerText
    from.innerText = elems[0].innerText
    time.innerText = elems[3].innerText
    maintext.innerText = elems[2].innerText
}


window.onload = function() {
    // フォームの隠しフィールドを初期化
    document.getElementById('filepath_input').value = '';

    index = 1

    // すべてのtd要素を取得
    var cells = document.querySelectorAll('td[filepath]');
    // 各td要素にクリックイベントリスナーを追加
    cells.forEach(function(cell) {
        cell.addEventListener('click', show_detail);
        cell.className = "col" + "_" + index.toString() + " cols";
        index++;
    });
}