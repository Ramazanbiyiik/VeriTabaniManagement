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
    public partial class FrmBransPaneli : Form
    {
        public FrmBransPaneli()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl = new SqlBaglanti();
        private void FrmBransPaneli_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select * From brans", bgl.baglanti());
            da.Fill(dt);
            dataGridView1.DataSource = dt;
        }

        private void BtnEkle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut1 = new NpgsqlCommand("insert into brans (ad,branstipi) values (@p2,@p3)", bgl.baglanti());
            komut1.Parameters.AddWithValue("@p2", TxtBransAd.Text);
            komut1.Parameters.AddWithValue("@p3", txtbransturu.Text);
            komut1.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Brans Eklenmesi Yapilmistir.","Bilgi",MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void BtnSil_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut2 = new NpgsqlCommand("Delete From brans where Bransid=@p1", bgl.baglanti());
            komut2.Parameters.AddWithValue("@p1",TxtBransid.Text);
            komut2.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Brans Silme İşlemi Yapilmistir.","Bilgi",MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void BtnGuncelle_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut3 = new NpgsqlCommand("Update brans set  ad=@p2 branstipi=@p2 where Bransid=@p1",bgl.baglanti()); 
            komut3.Parameters.AddWithValue("@p2",TxtBransAd.Text);
            komut3.Parameters.AddWithValue("@p1",TxtBransid.Text);
            komut3.Parameters.AddWithValue("@p3",txtbransturu.Text);
            komut3.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Brans Guncelleme islemi Yapilmistir.", "Bilgi", MessageBoxButtons.OK, MessageBoxIcon.Information);

             

        }

        private void dataGridView1_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int secilen = dataGridView1.SelectedCells[0].RowIndex;
            TxtBransid.Text = dataGridView1.Rows[secilen].Cells[0].Value.ToString();
            TxtBransAd.Text = dataGridView1.Rows[secilen].Cells[1].Value.ToString();
            txtbransturu.Text = dataGridView1.Rows[secilen].Cells[2].Value.ToString();
        }

        private void label1_Click(object sender, EventArgs e)
        {

        }
    }
}
