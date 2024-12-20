using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;

namespace Proje_Hastane
{
    public partial class FrmDoktorDetay : Form
    {
        public FrmDoktorDetay()
        {
            InitializeComponent();
        }
        public string doktorTc;
        SqlBaglanti bgl = new SqlBaglanti();
        private void FrmDoktorDetay_Load(object sender, EventArgs e)
        {
            lblTc.Text = doktorTc;
            //ad soyad çekme 
            NpgsqlCommand komut1 = new NpgsqlCommand("Select ad ,soyad From doktor where tcno=@p1 ", bgl.baglanti());
            komut1.Parameters.AddWithValue("@p1", lblTc.Text);
            NpgsqlDataReader dr1 = komut1.ExecuteReader();

            while (dr1.Read())
            {
                LblAdSoyad.Text = dr1[0] + " " + dr1[1];
            }
            bgl.baglanti().Close();

            //Doktora ait Randevuları çekme
            DataSet ds = new DataSet();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select * From randevular where doktorad='" + LblAdSoyad.Text + "'", bgl.baglanti());
            da.Fill(ds);
            dataGridView1.DataSource = ds.Tables[0];
        }

        private void BtnGuncelle_Click(object sender, EventArgs e)
        {
            FrmDoktorBilgiDuzenle frm = new FrmDoktorBilgiDuzenle();
            frm.tcDoktor = lblTc.Text;
            frm.Show();
        }

        private void BtnDuyurular_Click(object sender, EventArgs e)
        {
            FrmDuyurular frm = new FrmDuyurular();
            frm.Show();
        }

        private void BtnCikis_Click(object sender, EventArgs e)
        {
            FrmGirisler frm = new FrmGirisler();
            frm.Show();
            this.Hide();
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            RchRandevuDetay.Text=dataGridView1.Rows[secilen].Cells[7].Value.ToString();
        }
    }
}
