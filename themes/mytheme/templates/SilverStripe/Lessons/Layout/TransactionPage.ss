<div class="content">
    $Content
	<div class="container">
		<div class="row">
            <div id="baseUrl" data-url="{$BaseHref}transaction/"></div>

            <!-- BEGIN MAIN CONTENT -->

            <div class="main col-sm">
                <div class="card">
                    <div class="card-body">
                        <div class="row" style="margin-top: 50px;">
                            <form id="search_field" method="POST">

                                <div class="col-sm-4">
                                    <input type="text" name="Name" class="form-control search" placeholder="Search Name...">
                                </div>

                                <div class="col-sm-4">
                                    <input type="text" name="Address"  class="form-control search" placeholder="Search Address...">
                                </div>

                                <div class="col-sm-4">
                                    <input type="text" name="Phone" class="form-control search" placeholder="Search Phone...">
                                </div>

                                <button style="float: right; margin-right: 17px;" type="submit" class="btn btn-sm btn-gray">Search</button>
                                <button type="button" class="btn btn-sm btn-gray" style="float: right; margin-right: 17px" id="reset-form">
                                    Reset
                                </button>
                                <!-- <button type="button" class="btn btn-primary" id="test"></button> -->
                            </form>

                            <div class="row">
                                <div class="col-sm-8">
                                    <div class="table table-responsive">
                                        <table class="table table-responsive table-hover" style="margin-top: 50px;" id="table">
                                            <thead>
                                             <tr>
                                                 <th>Kode</th>
                                                 <th>Name</th>
                                                 <th>Date</th>
                                                 <th>Total</th>
                                                 <th>Action</th>
                                             </tr>
                                            </thead>

                                         </table>
                                    </div>
                                </div>

                                <div class="col-sm-4" style="margin-top: 50px;">
                                    <form id="create" method="POST">
                                        <div class="card border-light mb-3">
                                            <div class="card-header">
                                                Create
                                            </div>
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <label for="">Name</label>
                                                    <input type="text" name="Name" class="form-control">
                                                </div>
                                                <div class="form-group datepicker_wrapper">
                                                    <label for="">Date</label>
                                                    <input type="date" name="Date" class="form-control date">
                                                </div>
                                                <div class="form-group">
                                                    <label for="">Description</label>
                                                    <textarea name="Description" class="form-control" rows="5"></textarea>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="card">
                                            <div class="card-header text-right" style="margin-bottom: 30px;">
                                                <button type="button" id="addDetail" class="text-right">Add</button>
                                            </div>

                                            <div class="card-body" id="detail">
                                            </div>
                                            <div class="card-footer">
                                                <div class="row">
                                                    <div class="col-sm-8 text-right">
                                                        <label for="">Total : </label>
                                                    </div>
                                                    <div class="col-sm-3">
                                                        <input type="text" readonly name="Total" class="form-control text-right" id="total">
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="text-right">
                                            <button type="reset">Reset</button>
                                            <button type="submit">Submit</button>
                                        </div>
                                    </form>
                                </div>
                            </div>


                        </div>
                    </div>
                </div>
			</div>

		</div>
	</div>
</div>

<script>
    var params = [];
    var table;
    var sorting = [];
    let url = $("#baseUrl").data('url');

    var i = 0;

    $(document).ready(function () {

        // $('.date').datepicker({
        //     dateFormat: "dd-mm-yyyy"
        // })

        $('#create').submit(function (e) {
            e.preventDefault();

            $.ajax({
                type: "post",
                url: url+'store',
                data: new FormData(this),
                dataType: "json",
                processData: false,
                contentType: false,
                success: function (response) {
                    Swal.fire(
                        'Saved',
                        response.message,
                        'success'
                    );
                    $(this).trigger('reset');
                }
            });
        });

        //Add detail
        $(document).on('click','#addDetail', function(){

            $('#detail').append(`
                <div class="row">
                    <div class="col-sm-3">
                        <select name="detail[${i}][ProductID]" class="form-control product">
                            <option value="0">...</option>
                            <% loop $getProduct %>
                                <option value="$ID">$Name</option>
                            <% end_loop %>
                        </select>
                    </div>

                    <div class="col-sm-2">
                        <input type="text" name="detail[${i}][Qty]" placeholder="Qty" class="form-control text-right qty">
                    </div>

                    <div class="col-sm-3">
                        <input type="text" name="detail[${i}][Price]" readonly class="form-control price text-right" placeholder="Price">
                    </div>

                    <div class="col-sm-3">
                        <input type="text" name="detail[${i}][Subtotal]" readonly class="form-control text-right subtotal" placeholder="Subtotal">
                    </div>

                    <div class="col-sm-1">
                        <button type="button" class="deleteDetail btn btn-danger"></button>
                    </div>
                </div>`
            );
            const formatCur = {mDec:0 , aSep:'.', aDec:',', asign:"Rp."};
            $('.qty').autoNumeric('init', formatCur);
            $('.subtotal').autoNumeric('init', formatCur);

            i++;

            $('.qty').keyup(function (e) {
                subtotal($(this));
            });

            $('.product').change(function (e) {
                e.preventDefault();
                var id = $(this).val();
                let price = $(this).parent().parent().find('.price');
                let here = $(this);
                price.autoNumeric('init',formatCur);

                $.ajax({
                    type: "get",
                    url: url+'getPrice',
                    data: {'id' : id},
                    dataType: "json",
                    success: function (response) {
                        price.val(response.data.Price);
                        subtotal(here);
                    }
                });

            });
        });

        $(document).on('click', '.deleteDetail', function(){

            const swalWithBootstrapButtons = Swal.mixin({
            customClass: {
                confirmButton: 'btn btn-success',
                cancelButton: 'btn btn-danger'
            },
            buttonsStyling: false
            })

            swalWithBootstrapButtons.fire({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'No, cancel!',
            reverseButtons: true
            }).then((result) => {
            if (result.isConfirmed) {

                swalWithBootstrapButtons.fire(
                'Deleted!',
                'Your file has been deleted.',
                'success'
                );
                $(this).parent().parent().remove()

                total();

            } else if (
                /* Read more about handling dismissals below */
                result.dismiss === Swal.DismissReason.cancel
            ) {
                swalWithBootstrapButtons.fire(
                'Cancelled',
                'Your imaginary file is safe :)',
                'error'
                )
            }
            });
        });

        //DataTable
        table = $('#table').DataTable({
            "responsive": true,
            "processing" : true,
            "serverSide" : true,
            "paging" : true,
            "searching" : false,
            "ordering" : true,
            'language':{
                    "decimal":        "",
                    "emptyTable":     "Tidak ada data di dalam table",
                    "info":           "Menampilkan _START_ - _END_ dari total _TOTAL_ data pada kolom _PAGE_ dari _PAGES_ kolom ",
                    "infoEmpty":      "Data tidak ditemukan",
                    "infoFiltered":   "(Mencari dari _MAX_ total data)",
                    "infoPostFix":    "",
                    "thousands":      ",",
                    "lengthMenu":     "Menampilkan _MENU_ data",
                    "loadingRecords": "Loading...",
                    "processing":     "Processing...",
                    "search":         "Cari:",
                    "zeroRecords":    "Tidak ada data yang ditemukan",
                    "paginate": {
                        "first":      "Pertama",
                        "last":       "Terakhir",
                        "next":       ">",
                        "previous":   "<"
                    },
                    "aria": {
                        "sortAscending":  ": activate to sort column ascending",
                        "sortDescending": ": activate to sort column descending"
                    }
                },
                "order": [[ 1, 'asc' ]],
                "ajax" : {
                    "url" : url+"getData",
                    data : function(d){
                        d.filter_record = params,
                        d.sorting = sorting
                    }
                },

                "columnDefs": [ {
                    // "searchable": true,
                    "orderable": false,
                    "targets": [3,4],
                } ],
                "deferRender" : true,
        });

    });

    // to count subtotal
    function subtotal(data){
        const formatCur = {mDec:0 , aSep:'.', aDec:',', asign:"Rp."};

        var parent = data.parent().parent();
        var qty = parent.find('.qty').val().split('.').join('');
        var price = parent.find('.price').val().split('.').join('');
        var subtotal = Number(qty) * Number(price);

        // console.log(subtotal.toLocaleString('de-DE'));
        parent.find('.subtotal').val(formatNumber(subtotal));

        total();
    }

    // to count total
    function total(){
        let subtotal = document.querySelectorAll('.subtotal');
        var total = 0;
        subtotal.forEach(element => {

            total += Number(element.value.split('.').join(''));
        });

        document.querySelector('#total').value = formatNumber(total);
    }

    //make format Number
    function formatNumber(number){
        return number.toLocaleString('de-DE');
    }

</script>

