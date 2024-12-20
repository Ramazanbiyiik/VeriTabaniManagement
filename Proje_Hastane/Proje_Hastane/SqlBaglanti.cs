using Npgsql;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace Proje_Hastane
{
    internal class SqlBaglanti
    {
        public NpgsqlConnection baglanti()
        {
           NpgsqlConnection baglanti = new NpgsqlConnection("server=localHost ; port = 5432 ; Database=hastaneDb1 ; username=postgres ; password = 246811Ra");
           baglanti.Open();
           return baglanti;
        }
    }
}
