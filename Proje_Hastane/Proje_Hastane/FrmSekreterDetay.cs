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
    public partial class FrmSekreterDetay : Form
    {
        public FrmSekreterDetay()
        {
            InitializeComponent();
        }
        public string sekreterTc;
        SqlBaglanti bgl = new SqlBaglanti();

        private void FrmSekreterDetay_Load(object sender, EventArgs e)
        {
            lblTc.Text = sekreterTc;
            //ad Soyad çekme
            NpgsqlCommand komut1 = new NpgsqlCommand("Select ad , soyad  From sekreter Where tcno=@p1", bgl.baglanti());
            komut1.Parameters.AddWithValue("@p1",lblTc.Text);
            NpgsqlDataReader dr1 = komut1.ExecuteReader();
            while(dr1.Read())
            {
                LblAdSoyad.Text= dr1[0] + " " + dr1[1];
            }
            bgl.baglanti().Close();

            //Bransları datagride cekme
            DataTable dt1 = new DataTable();
            NpgsqlDataAdapter da1 = new NpgsqlDataAdapter("Select * From brans ", bgl.baglanti());
            da1.Fill(dt1);
            dataGridView1.DataSource = dt1;

           // Doktor verileri cekme
              DataTable dt2 = new DataTable();
              NpgsqlDataAdapter da2 = new NpgsqlDataAdapter("Select ad , soyad , bransad From doktor ", bgl.baglanti());
              da2.Fill(dt2);
              dataGridView2.DataSource = dt2;

            //Brans Cekme
            NpgsqlCommand komut2 = new NpgsqlCommand("Select ad From brans",bgl.baglanti());
            NpgsqlDataReader dr2 = komut2.ExecuteReader();
            while(dr2.Read())
            {
                CmbBrans.Items.Add(dr2[0]);
            }
            bgl.baglanti().Close();



        }

        private void CmbDoktor_SelectedIndexChanged(object sender, EventArgs e)
        {
            //CmbDoktor.Items.Clear();

           // SqlCommand komut3 =new SqlCommand("Select DoktorAd From Tbl_Doktorlar wh"
        }

        private void BtnKaydet_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komutKaydet = new NpgsqlCommand("insert into randevular (tarih,saat,bransad,doktorad) values (@r1,@r2,@r3,@r4)", bgl.baglanti());
            komutKaydet.Parameters.AddWithValue("@r1",MskTarih.Text);
            komutKaydet.Parameters.AddWithValue("@r2",MskSaat.Text);
            komutKaydet.Parameters.AddWithValue("@r3",CmbBrans.Text);
            komutKaydet.Parameters.AddWithValue("@r4", CmbDoktor.Text);
            komutKaydet.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Randevu Oluşturuldu");

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

        private void BtnOlustur_Click(object sender, EventArgs e)
        {
            NpgsqlCommand komut = new NpgsqlCommand("insert into duyuru (duyuruicerik) values(@d1)", bgl.baglanti());
            komut.Parameters.AddWithValue("@d1",RchRandevuDetay.Text);
            komut.ExecuteNonQuery();
            bgl.baglanti().Close();
            MessageBox.Show("Duyuru oluşturuldu !");
        }

        private void BtnDoktorPaneli_Click(object sender, EventArgs e)
        {
            FrmDoktorPaneli fr = new FrmDoktorPaneli();
            fr.Show();
        }

        private void BtnBransPaneli_Click(object sender, EventArgs e)
        {
            FrmBransPaneli fr = new FrmBransPaneli();
            fr.Show();
        }

        private void BtnRandevuListele_Click(object sender, EventArgs e)
        {
            FrmRandevuListesi fr = new FrmRandevuListesi();
            fr.Show();
        }

        private void BtnDuyurular_Click(object sender, EventArgs e)
        {
            FrmDuyurular fr = new FrmDuyurular();
            fr.Show();
        }

        private void groupBox3_Enter(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            FrmFatura fr = new FrmFatura();
            fr.Show();
        }
    }
}
