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
    public partial class FrmHastaDetay : Form
    {
        public FrmHastaDetay()
        {
            InitializeComponent();
        }
        SqlBaglanti bgl = new SqlBaglanti();
        public string tc;
        private void BtnRandevuAl_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("Update randevular set randevudurum=True,hastatc=@p1,hastasikayet=@p2 where randevuid=@p3", bgl.baglanti());
            komut.Parameters.AddWithValue("@p1",lblTc.Text);
            komut.Parameters.AddWithValue("@p2",RchSikayet.Text);
            komut.Parameters.AddWithValue("@p3",int.Parse(Txtid.Text));
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Randevu Alindi.","UYARI",MessageBoxButtons.OK,MessageBoxIcon.Warning); 
        }

        private void CmbBrans_SelectedIndexChanged(object sender, EventArgs e)
        {
            // doktor cekme
            CmbDoktor.Items.Clear();
            NpgsqlCommand komut3 = new NpgsqlCommand("Select ad ,soyad From doktor where bransad=@p1", bgl.baglanti());
            komut3.Parameters.AddWithValue("@p1", CmbBrans.Text);
            NpgsqlDataReader dr3 = komut3.ExecuteReader();
            while (dr3.Read())
            {
                CmbDoktor.Items.Add(dr3[0] + " " + dr3[1]);
            }
            bgl.baglanti().Close();
        }

        private void FrmHastaDetay_Load(object sender, EventArgs e)
        {
            lblTc.Text = tc;

            //Ad Soyad çekme
            NpgsqlCommand komut1 = new NpgsqlCommand("Select ad, soyad From hasta where tcno=@p1", bgl.baglanti());
            komut1.Parameters.AddWithValue("@p1", tc);
            NpgsqlDataReader dr1 = komut1.ExecuteReader();

            while (dr1.Read())
            {
                LblAdSoyad.Text = dr1[0] + " " + dr1[1];
            }
            bgl.baglanti().Close();

            //Randevu Gecmisi
            
            //NpgsqlDataAdapter da = new NpgsqlDataAdapter("Select From randevular Where hastatc" + tc, bgl.baglanti());
           // DataSet ds = new DataSet();
           // da.Fill(ds);
           // dataGridView1.DataSource = ds.Tables[1];

            //Branslari cekme 

            NpgsqlCommand komut2 = new NpgsqlCommand("Select ad From brans", bgl.baglanti());
            NpgsqlDataReader dr2 = komut2.ExecuteReader();
            while (dr2.Read())
            {
                CmbBrans.Items.Add(dr2[0]);
            }
            bgl.baglanti().Close();

        }

        private void CmbDoktor_SelectedIndexChanged(object sender, EventArgs e)
        {
            
            NpgsqlDataAdapter da= new NpgsqlDataAdapter("Select * From randevular INNER JOIN brans ON randevular.bransid = brans.bransid Where ad= '" + CmbBrans.Text + "'" + " and doktorad='" + CmbDoktor.Text + "'and randevudurum=False", bgl.baglanti());
            DataSet ds = new DataSet();
            da.Fill(ds);
            dataGridView2.DataSource = ds.Tables[0];  
        }

        private void LnkBilgiDuzenle_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            FrmHastaBilgiDuzenle fr = new FrmHastaBilgiDuzenle();
            fr.tcNo= lblTc.Text;
            fr.Show();

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }

        private void dataGridView2_CellDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            int secilen = dataGridView2.SelectedCells[0].RowIndex;
            Txtid.Text = dataGridView2.Rows[secilen].Cells[0].Value.ToString();
        }
    }
}
