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
    public partial class FrmDoktorPaneli : Form
    {
        public FrmDoktorPaneli()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl = new SqlBaglanti();
        private void FrmDoktorPaneli_Load(object sender, EventArgs e)
        {

            // Doktor verileri cekme
            DataTable dt1 = new DataTable();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select * From doktor ", bgl.baglanti());
            da.Fill(dt1);
            dataGridView1.DataSource = dt1;

            //Brans Cekme
            NpgsqlCommand komut2 = new NpgsqlCommand("Select ad From brans", bgl.baglanti());
            NpgsqlDataReader dr2 = komut2.ExecuteReader();
            while (dr2.Read())
            {
                CmbBrans.Items.Add(dr2[0]);
            }
            bgl.baglanti().Close();
        }

        private void BtnEkle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("insert into doktor (ad ,soyad, bransad ,tcno , personelsifre) values (@p1,@p2,@p3,@p4,@p5)", bgl.baglanti());
            komut.Parameters.AddWithValue("@p1",TxtAd.Text);
            komut.Parameters.AddWithValue("@p2",TxtSoyad.Text);
            komut.Parameters.AddWithValue("@p3",CmbBrans.Text);
            komut.Parameters.AddWithValue("@p4",MskTc.Text);
            komut.Parameters.AddWithValue("@p5",TxtSifre.Text);
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Doktor Eklendi","Bilgi",MessageBoxButtons.OK, MessageBoxIcon.Hand);
        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            TxtAd.Text = dataGridView1.Rows[secilen].Cells[1].Value.ToString();
            TxtSoyad.Text = dataGridView1.Rows[secilen].Cells[2].Value.ToString();
            CmbBrans.Text = dataGridView1.Rows[secilen].Cells[8].Value.ToString();
            MskTc.Text = dataGridView1.Rows[secilen].Cells[3].Value.ToString();
            TxtSifre.Text = dataGridView1.Rows[secilen].Cells[5].Value.ToString();
        }

        private void BtnSil_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("Delete From doktor where tcno=@p1", bgl.baglanti());
            komut.Parameters.AddWithValue("@p1",MskTc.Text);
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Kayıt Silindi.","UYARI",MessageBoxButtons.OK, MessageBoxIcon.Warning);
        }

        private void BtnGuncelle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("Update doktor set ad=@p1,soyad=@p2,bransad=@p3,personelsifre=@p4 where tcno=@p5", bgl.baglanti());
            komut.Parameters.AddWithValue("@p1",TxtAd.Text);
            komut.Parameters.AddWithValue("@p2",TxtSoyad.Text); 
            komut.Parameters.AddWithValue("@p3",CmbBrans.Text);
            komut.Parameters.AddWithValue("@p4",TxtSifre.Text);
            komut.Parameters.AddWithValue("@p5",MskTc.Text);
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Doktor Bilgiler Güncellendi", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);
            
        }
    }
}
